package i18n

// HTML strings — see en.go for tag and escaping rules.
// RTL: each Persian message starts with U+200F (RIGHT-TO-LEFT MARK) so
// Telegram's BiDi algorithm forces right-to-left layout even when the first
// visible character is a neutral emoji.
const rlm = "\u200F"

var fa = map[Key]string{
	Welcome: rlm + "👋 <b>به ربات %s خوش آمدید.</b>\n\n" +
		"از این ربات می‌توانید:\n" +
		"• 🔗 یک اکانت VPN موجود را لینک کنید\n" +
		"• 📊 مصرف و تاریخ انقضا را ببینید\n" +
		"• 🔄 درخواست تمدید بدهید\n" +
		"• 🆕 سفارش اکانت جدید ثبت کنید\n" +
		"• 🔔 هشدار خودکار کم شدن حجم دریافت کنید",

	BotDisabled: rlm + "⚠️ ربات در حال حاضر توسط ادمین غیرفعال شده است. لطفاً بعداً مراجعه کنید.",
	MainMenu:    rlm + "📋 <b>منوی اصلی</b>\nچه کاری می‌خواهید انجام دهید؟",

	BtnAddAccount: rlm + "افزودن اکانت 🔗",
	BtnMyAccounts: rlm + "اکانت‌های من 👤",
	BtnNewOrder:   rlm + "سفارش اکانت جدید 🆕",
	BtnHelp:       rlm + "راهنما ℹ️",
	BtnLanguage:   rlm + "زبان 🌐",
	BtnCancel:     rlm + "انصراف ❌",
	BtnBack:       rlm + "بازگشت ⬅️",
	BtnUsage:      rlm + "مصرف 📊",
	BtnRenew:      rlm + "تمدید 🔄",
	BtnRemove:     rlm + "حذف لینک 🗑",

	AskUsername:    rlm + "🔑 لطفاً <b>نام کاربری</b> اکانت VPN خود را ارسال کنید:",
	AskPassword:    rlm + "🔒 حالا <b>رمز عبور</b> اکانت VPN را ارسال کنید (پیام شما بلافاصله حذف می‌شود):",
	AskUsernameNew: rlm + "📝 یک نام کاربری برای اکانت جدید انتخاب کنید (۳ تا ۳۲ کاراکتر، حروف لاتین، عدد و <code>_ - .</code>):",
	AskMessage:     rlm + "💬 می‌توانید توضیح اختیاری برای ادمین بنویسید، یا /skip را بفرستید تا رد شوید:",
	AskReceipt:     rlm + "🧾 لطفاً تصویر رسید پرداخت را به‌صورت <b>عکس</b> ارسال کنید.",

	AuthSuccess:   rlm + "✅ اکانت با موفقیت لینک شد.",
	AuthFail:      rlm + "❌ نام کاربری یا رمز عبور اشتباه است.",
	AuthLocked:    rlm + "🔒 اکانت شما قفل شده است. لطفاً با ادمین تماس بگیرید.",
	AlreadyLinked: rlm + "ℹ️ این اکانت قبلاً به چت تلگرام شما لینک شده است.",

	NoAccounts: rlm + "📭 هنوز اکانتی لینک نکرده‌اید. از منوی اصلی <b>افزودن اکانت</b> را انتخاب کنید.",
	NoPackages: rlm + "📦 در حال حاضر پکیج فعالی وجود ندارد. لطفاً بعداً مراجعه کنید.",
	PickPackage: rlm + "📦 <b>یک پکیج انتخاب کنید:</b>",

	PickAccountRenew: rlm + "🔄 اکانتی را برای تمدید انتخاب کنید:",
	RequestCreated:   rlm + "📨 درخواست شما ثبت شد. ادمین به‌زودی بررسی می‌کند.",
	RequestExists:    rlm + "⏳ یک درخواست در حال بررسی دارید. لطفاً تا تعیین تکلیف صبر کنید.",
	WaitForApproval:  rlm + "⏳ در انتظار تایید ادمین…",
	NotApprovedYet:   rlm + "ℹ️ درخواست شما هنوز تایید نشده، امکان ارسال رسید وجود ندارد.",
	ReceiptSaved:     rlm + "🧾 رسید دریافت شد. در انتظار تایید نهایی ادمین.",
	OnlyPhoto:        rlm + "📷 لطفاً رسید را به‌صورت عکس ارسال کنید.",

	HelpText: rlm + "<b>راهنمای ربات داشبورد Ocserv</b>\n\n" +
		"از دکمه‌های inline برای مدیریت اکانت‌ها، مشاهدهٔ مصرف، درخواست تمدید، سفارش اکانت جدید و ارسال رسید پرداخت استفاده کنید.\n\n" +
		"دستورها:\n" +
		"• /start — منوی اصلی\n" +
		"• /help — این راهنما\n" +
		"• /settings — تنظیمات زبان\n" +
		"• /cancel — لغو عملیات",

	UsageText: rlm + "👤 <b>اکانت:</b> <code>%s</code>\n" +
		"📌 <b>وضعیت:</b> %s\n" +
		"💾 <b>حجم بسته:</b> %d GB\n" +
		"⬇️ <b>مصرف دریافت:</b> %.2f GB\n" +
		"⬆️ <b>مصرف ارسال:</b> %.2f GB\n" +
		"📅 <b>انقضا:</b> %s",

	AccountRemoved: rlm + "🗑 لینک اکانت از چت تلگرام شما حذف شد.",
	NotLinked:      rlm + "❓ این اکانت به چت تلگرام شما لینک نیست.",
	UnknownCommand: rlm + "🤔 دستور نامعتبر. از دکمه‌های منو استفاده کنید.",

	LowQuotaWarning: rlm + "🔔 <b>هشدار حجم اکانت</b> <code>%s</code>: فقط %d مگابایت باقی مانده. لطفاً برای تمدید اقدام کنید.",

	LanguagePicked:    rlm + "✅ زبان با موفقیت تغییر کرد.",
	SessionTimedOut:   rlm + "⌛ جلسه منقضی شد. لطفاً از منوی اصلی دوباره تلاش کنید.",
	OcservDeactivated: rlm + "⛔ این اکانت غیرفعال است.",
	RateLimited:       rlm + "🚦 تعداد تلاش‌ها زیاد است. لطفاً یک دقیقه صبر کنید.",

	// Admin
	AdminWelcome: rlm + "🛡 <b>پنل ادمین — %s</b>\n\n" +
		"شما به‌عنوان <b>ادمین</b> وارد شده‌اید.\n" +
		"از دکمه‌های زیر برای مدیریت درخواست‌ها و نظارت بر ربات استفاده کنید.",
	AdminMenu: rlm + "🛡 <b>پنل ادمین</b>\nیک گزینه انتخاب کنید:",

	BtnAdminPending:  rlm + "درخواست‌های در انتظار 📥",
	BtnAdminReceipts: rlm + "رسیدهای پرداخت 🧾",
	BtnAdminStats:    rlm + "آمار ربات 📊",
	BtnAdminUserView: rlm + "نمای کاربر عادی 👤",
	BtnAdminBack:     rlm + "بازگشت به پنل ادمین 🔙",
	BtnOpenPanel:     rlm + "پنل وب 🌐",

	AdminNoPending: rlm + "📭 درخواست در انتظاری وجود ندارد.",
	AdminNoReceipts: rlm + "📭 رسیدی برای تایید وجود ندارد.",

	AdminStatsText: rlm + "📊 <b>آمار ربات</b>\n\n" +
		"• اکانت‌های لینک‌شده: <b>%d</b>\n" +
		"• پکیج‌های فعال: <b>%d</b>\n" +
		"• درخواست‌های در انتظار: <b>%d</b>\n" +
		"• در انتظار پرداخت: <b>%d</b>\n" +
		"• رسیدهای آپلودشده: <b>%d</b>",

	AdminRequestRow: "<b>#%d</b> · %s · <code>%s</code>\n" +
		"📝 %s\n" +
		"🕒 %s",
}
