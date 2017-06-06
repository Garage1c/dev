

Процедура ДобавитьДеревоПоСтруктурам(Текст, Структура)
	
	Для Каждого Элемент Из Структура Цикл
		
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") ИЛИ  ТипЗнч(Элемент.Значение) = Тип("Соответствие") Тогда	// узел дерева
			
			Текст = Текст + "
			|<li>" + Элемент.Ключ + "<ul>";
			
			ДобавитьДеревоПоСтруктурам(Текст, Элемент.Значение);
			
			Текст = Текст + "
			|</ul></li>" + Элемент.Ключ;
			
		Иначе													// нижний уровень
			
			Текст = Текст + "
			|<li>" + Элемент.Ключ + ": " + Элемент.Значение + "</li>";
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
Функция ПолучитьHTMLПоСтруктуре(Структура) Экспорт

	Текст = "<!DOCTYPE HTML>
	|<html>
	|<head>
	|<style>
	|* html body {
	|  behavior:url(""csshover.htc""); /* IE6: http://www.xs4all.nl/~peterned/csshover.html */
	|}
    |
	|.tree span:hover {
	|  font-weight: bold;
	|}
	|.tree span {
	|  cursor: pointer;
	|}
	|</style>
	|<meta charset=""utf-8"">
	|</head>
	|<body>
    |
	|<ul class=""tree"">
	|";
	
	ДобавитьДеревоПоСтруктурам(Текст, Структура);
	
	Текст = Текст + "
	|<script>
    |
	|var tree = document.getElementsByTagName('ul')[0];
	|var treeLis = tree.getElementsByTagName('li');
	|
	|/* wrap all textNodes into spans */
	|for(var i=0; i<treeLis.length; i++) {
	|  var li = treeLis[i];
    |
	|  var span = document.createElement('span');
	|  li.insertBefore(span, li.firstChild);
	|  span.appendChild(span.nextSibling);
	|}
	|
	|/* catch clicks on whole tree */
	|tree.onclick = function(evt) {
	|  evt = evt || window.event;
	|  var target = evt.target || evt.srcElement;
    |
	|  if (target.tagName != 'SPAN') {
	|	return;
	|  }
	|
	|  /* now we know SPAN is clicked */
	|  var node = target.parentNode.getElementsByTagName('ul')[0];
	|  if (!node) return; // no children
    |
	|  node.style.display = node.style.display ? '' : 'none';
	|}
	|/*
	|tree.onselectstart = tree.onmousedown = function() {
	|  return false; // делаем узлы невыделяемыми
	|}
	|*/
 	|</script>
	|</body>
	|</html>
	|";

	Возврат Текст;
	
КонецФункции