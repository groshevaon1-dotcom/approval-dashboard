# Обновляет сайт: берёт свежий дашборд из папки «Торги», оборачивает в index.html и публикует на GitHub.
$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
$src  = 'D:\Мои документы\Claude\Услуги в сфере ИИ и земли\Торги\Дашборд_предв_согласования.html'

$body = [IO.File]::ReadAllText($src)
if ($body -notmatch '^\s*<!doctype') {
  $i = $body.IndexOf('</style>') + 8
  $head = "<!doctype html>`n<html lang=`"ru`">`n<head>`n<meta charset=`"utf-8`">`n<meta name=`"viewport`" content=`"width=device-width, initial-scale=1`">`n"
  $body = $head + $body.Substring(0, $i) + "`n</head>`n<body>`n" + $body.Substring($i) + "`n</body>`n</html>`n"
}
[IO.File]::WriteAllText("$repo\index.html", $body, (New-Object Text.UTF8Encoding $false))

Set-Location $repo
git add index.html
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) { Write-Host 'Дашборд не изменился — публиковать нечего.'; exit 0 }

$date = (Get-Item $src).LastWriteTime.ToString('dd.MM.yyyy')
git commit -q -m "Обновление данных от $date"
git push -q origin main
Write-Host "Готово: сайт обновлён (данные от $date)."
