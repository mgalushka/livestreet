function ajaxTextPreview(textId,save,divPreview) { 
	var text;    
	if (BLOG_USE_TINYMCE && tinyMCE && (ed=tinyMCE.get(textId))) {
		text = ed.getContent();
	} else {
		text = $(textId).value;	
	}	
	JsHttpRequest.query(
    	DIR_WEB_ROOT+'/include/ajax/textPreview.php',                       
        { text: text, save: save },
        function(result, errors) {  
        	if (!result) {
                msgErrorBox.alert('Error','Please try again later');           
        	}
            if (result.bStateError) {
            	msgErrorBox.alert('Ошибка','Возникли проблемы при обработке предпросмотра');
            } else {    	
            	if (!divPreview) {
            		divPreview='text_preview';
            	}            	
            	if ($(divPreview)) {
            		$(divPreview).set('html',result.sText).setStyle('display','block');
            	}
            }                               
        },
        true
    );
}


// для опроса
function addField(btn){
        tr = btn;
        while (tr.tagName != 'TR') tr = tr.parentNode;
        var newTr = tr.parentNode.insertBefore(tr.cloneNode(true),tr.nextSibling);
        checkFieldForLast();
}
function checkFieldForLast(){	
        btns = document.getElementsByName('drop_answer');      
        for (i = 0; i < btns.length; i++){
        	btns[i].disabled = false;            
        }
        if (btns.length<=2) {
        	btns[0].disabled = true;
        	btns[1].disabled = true;
        }
}
function dropField(btn){	
        tr = btn;
        while (tr.tagName != 'TR') tr = tr.parentNode;
        tr.parentNode.removeChild(tr);
        checkFieldForLast();
}



function checkAllTalk(checkbox) {
	$$('.form_talks_checkbox').each(function(chk){
		if (checkbox.checked) {
			chk.checked=true;
		} else {
			chk.checked=false;
		}		
	});	
}


function showImgUploadForm() {	
	if (!winFormImgUpload) {
		winFormImgUpload=new StickyWinModal({content: $('uploadimg-form-content').get('html'), closeClassName: 'close-block'});
	}
	winFormImgUpload.show();
	winFormImgUpload.pin(true);
	
}

function hideImgUploadForm() {
	winFormImgUpload.hide();
}

var winFormImgUpload;

window.addEvent('domready', function() {  	
	var form=$('window_load_img');
	if (form) {
		form.setStyle('display','block');
    	winFormImgUpload=new StickyWinModal({content: form, closeClassName: 'close-block'});    
    	winFormImgUpload.pin(true);
    	winFormImgUpload.hide();
	}
});


function ajaxUploadImg(value,sToLoad) {
	sToLoad=$(sToLoad);
	var req = new JsHttpRequest();
	req.onreadystatechange = function() {
		if (req.readyState == 4) {
			if (req.responseJS.bStateError) {
				msgErrorBox.alert('Ошибка','Возникли проблемы при загрузке изображения, попробуйте еще разок. И на всякий случай проверьте правильность URL картинки');
			} else {				
				sToLoad.insertAtCursor(req.responseJS.sText);
				hideImgUploadForm();
			}
		}
	}
	req.open(null, DIR_WEB_ROOT+'/include/ajax/uploadImg.php', true);
	req.send( { value: value } );
}