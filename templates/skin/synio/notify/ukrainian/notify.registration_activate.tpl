Ви зареєструвалися на сайті <a href="{cfg name='path.root.web'}">{cfg name='view.name'}</a><br>
Ваші реєстраційні дані:<br>
&nbsp;&nbsp;&nbsp;ім'я користувача: <b>{$oUser->getLogin()}</b><br>
&nbsp;&nbsp;&nbsp;пароль: <b>{$sPassword}</b><br>
<br>
Для завершення реєстрації вам потрібно перейти за посиланням: 
<a href="{router page='registration'}activate/{$oUser->getActivateKey()}/">{router page='registration'}activate/{$oUser->getActivateKey()}/</a>

<br><br>
З повагою, адміністрація сайту <a href="{cfg name='path.root.web'}">{cfg name='view.name'}</a>