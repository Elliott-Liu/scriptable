import { loadData } from "Prayer Time/generics/fileManager";
import { calculateDistance, getFilePath, getLocation, isOnline } from "Prayer Time/utilities";
import { APIData, PrayerTime, Preferences } from "Prayer Time/types";
import { getDay, getNewData, saveNewData, getPrayerTimes, addStatusToPrayerTimes } from "Prayer Time/data";
import { createWidget } from "Prayer Time/widget";

const PREFERENCES: Preferences = {
	widget: {
		settings: {
			file: "Prayer Time",
			directory: "Prayer Time",
			size: "small",
			offline: 3,
		},
		display: {
			prayerTimes: [
				{ name: "fajr", display: "🌄", abbreviation: "FAJ" }, // Dawn
				// { name: "sunrise", display: "🌅", abbreviation: "SUR" }, // Sunrise
				{ name: "dhuhr", display: "🕛", abbreviation: "DHU" }, // Midday
				{ name: "asr", display: "🌞", abbreviation: "ASR" }, // Afternoon
				// { name: "sunset", display: "🌇", abbreviation: "SUS" }, // Sunset
				{ name: "maghrib", display: "🌆", abbreviation: "MAG" }, // Dusk
				{ name: "isha", display: "🌙", abbreviation: "ISH" }, // Night
				{ name: "imsak", display: "⭐", abbreviation: "IMS" }, // Pre-dawn
				// { name: "midnight", display: "🕛", abbreviation: "MID" }, // Midnight
				// { name: "firstthird", display: "🌌", abbreviation: "FTH" }, // Late Night
				// { name: "lastthird", display: "🌒", abbreviation: "LTH" }, // Pre-fajr
			],
		},
	},
	api: {
		endpoint: "https://api.aladhan.com/v1/timings/",
		location: {
			latitude: 0,
			longitude: 0,
		},
	},
};

(async () => {
	try {
		await runScript();
	} catch (error) {
		console.error(error);
	}
})();

async function runScript() {
	const {
		widget: {
			settings: { directory: directoryName, file: fileName, offline: offlineDays },
			display: { prayerTimes: userPrayerTimes },
		},
		api: { location },
	} = PREFERENCES;

	const DISTANCE_TOLERANCE_METRES = 1000; // 1KM
	const ITEMS_TO_SHOW = 5;

	const filePath = getFilePath(fileName, directoryName);
	const deviceOnline = await isOnline();

	let offlineDataDistanceMetres: number = 0;

	if (deviceOnline) {
		const today = new Date();
		const offlineData: APIData[] = await loadData(filePath);
		const todayData = getDay(offlineData, today);
		const numberOfPrayerTimes = getPrayerTimes(offlineData, userPrayerTimes).length;

		const { latitude: deviceLatitude, longitude: deviceLongitude } = await getLocation(PREFERENCES);
		PREFERENCES.api.location.latitude = deviceLatitude;
		PREFERENCES.api.location.longitude = deviceLongitude;

		if (todayData) {
			const { meta } = todayData;
			const distance = calculateDistance(location, meta);
			offlineDataDistanceMetres = Math.round((distance + Number.EPSILON) * 100) / 100;
		}

		if (location && (numberOfPrayerTimes <= ITEMS_TO_SHOW || offlineDataDistanceMetres > DISTANCE_TOLERANCE_METRES)) {
			const updatedData = await getNewData(PREFERENCES);
			await saveNewData(filePath, offlineDays, updatedData);
		}
	}

	const dayData = await loadData(filePath);

	if (dayData) presentData(dayData, userPrayerTimes, offlineDataDistanceMetres, ITEMS_TO_SHOW);
}

function presentData(dayData: APIData[], userPrayerTimes: PrayerTime[], distance: number, itemsToShow: number) {
	const sortedTimes = getPrayerTimes(dayData, userPrayerTimes, itemsToShow);
	const timings = addStatusToPrayerTimes(sortedTimes);
	createWidget(timings, userPrayerTimes, distance);
}
