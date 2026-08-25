export interface Course {
	slug: string;
	scheduleLabel: string;
	scheduleLabelDe: string;
	time?: string;
	title: string;
	titleDe: string;
	description: string;
	descriptionDe: string;
}

export const courses: Course[] = [
	{
		slug: 'grammatischer-gespraechskurs-b1-b2',
		scheduleLabel: 'ПОНЕДІЛОК АБО СЕРЕДА',
		scheduleLabelDe: 'MONTAG ODER MITTWOCH',
		time: '16:00 – 17:20',
		title: 'Граматичний розмовний гурток B1+/B2',
		titleDe: 'Grammatischer Gesprächskurs B1+/B2',
		description: 'Для тих, хто вже вчив B1+/B2 і під час розмови хотів би ширше використовувати набуті теоретичні знання. Тут не просто повторюють важливі конструкції, а вчаться автоматично використовувати їх у спонтанних розмовах на цікаві теми 🙂',
		descriptionDe: 'Für alle, die B1+/B2 gelernt haben und ihre theoretischen Kenntnisse im Gespräch sicherer anwenden möchten. Wir üben wichtige Strukturen und verwenden sie automatisch in spontanen Gesprächen über interessante Themen 🙂',
	},
	{
		slug: 'gespraechsgruppe-b1',
		scheduleLabel: 'СЕРЕДА',
		scheduleLabelDe: 'MITTWOCH',
		time: '14:30 – 15:50',
		title: 'Розмовна група В1 (DTZ / telc)',
		titleDe: 'Gesprächsgruppe B1 (DTZ / telc)',
		description: 'Тренуємо опис картинок і діалоги у форматі іспитів DTZ / telc, комбінуючи з граматикою та вивченням слів. На учасників чекають корисні стратегії, багато говоріння та позитивна компанія ✨',
		descriptionDe: 'Wir trainieren Bildbeschreibungen und Dialoge im Format der Prüfungen DTZ / telc, kombiniert mit Grammatik und Wortschatz. Dich erwarten hilfreiche Strategien, viel Sprechen und eine positive Gruppe ✨',
	},
	{
		slug: 'jugendlicher-gespraechskurs-b1-b2',
		scheduleLabel: 'П’ЯТНИЦЯ',
		scheduleLabelDe: 'FREITAG',
		time: '15:00 – 16:20',
		title: 'В1+/В2 молодіжний розмовний гурток (до 25 років)',
		titleDe: 'Jugendlicher Gesprächskurs B1+/B2 (bis 25 Jahre)',
		description: 'За обговоренням актуальних тем з однолітками ти забудеш, що це урок німецької, і прокачаєш розмовні навички із задоволенням :) ☀️ Фокус на спонтанному говорінні, яке поєднується з граматикою та лексикою.',
		descriptionDe: 'Beim Austausch über aktuelle Themen mit Gleichaltrigen vergisst du, dass es Deutschunterricht ist, und verbesserst deine Sprechfertigkeit mit Freude :) ☀️ Der Fokus liegt auf spontaner Kommunikation, kombiniert mit Grammatik und Wortschatz.',
	},
	{
		slug: 'deutschkurs-kinder-a2',
		scheduleLabel: 'З СЕРЕДИНИ ВЕРЕСНЯ',
		scheduleLabelDe: 'AB MITTE SEPTEMBER',
		title: 'Групові заняття для дітей 10–12 років (рівень ±A2)',
		titleDe: 'Gruppenunterricht für Kinder von 10–12 Jahren (Niveau etwa A2)',
		description: 'Працюємо насамперед над лексикою та розмовними навичками. Це вже більш системний курс: із домашніми завданнями, вправами та бажаним регулярним відвідуванням. 📚',
		descriptionDe: 'Wir arbeiten vor allem an Wortschatz und Sprechfertigkeit. Das ist ein systematischer Kurs mit Hausaufgaben, Übungen und möglichst regelmäßiger Teilnahme. 📚',
	},
];
