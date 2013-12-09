Вами надіслано запит на зміну email адреси користувача <a href="{$oUser->getUserWebPath()}">{$oUser->getLogin()}</a> на сайті <a href="{cfg name='path.root.web'}">{cfg name='view.name'}</a>.<br/>
Старий email: <b>{$oChangemail->getMailFrom()}</b><br/>
Новий email: <b>{$oChangemail->getMailTo()}</b><br/>


<br/>
Для підтвердження зміни email перейдіть за наступним посиланням:
<a href="{router page='profile'}changemail/confirm-from/{$oChangemail->getCodeFrom()}/">{router page='profile'}changemail/confirm-from/{$oChangemail->getCodeFrom()}/</a>

<br/><br/>
З повагою, адміністрація сайту <a href="{cfg name='path.root.web'}">{cfg name='view.name'}</a>