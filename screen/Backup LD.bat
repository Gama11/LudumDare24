SET CurrentDate=%date:~-4,4%%date:~-7,2%%date:~-10,2%
SET CurrentTIme=%time:~-11,2%%time:~-8,2%%time:~-5,2%
mkdir "C:\Users\Jens\Dropbox\Backups\CastleBreak\%CurrentDate%_T%CurrentTime%\"
xcopy /E "C:\Users\Jens\Dropbox\Flash Projekte\_LD_\*.*" "C:\Users\Jens\Desktop\Backups\%CurrentDate%_T%CurrentTime%\"
SET CurrentDate=
SET CurrentTime=