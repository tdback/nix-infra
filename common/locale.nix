{
  desktop,
  ...
}:
{
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  # Headless systems should use UTC.
  time.timeZone = if desktop then "America/Detroit" else "UTC";
}
