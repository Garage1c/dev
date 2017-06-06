
// ДЕРЕВО СВОЙСТВ

Процедура Tree01_ЗавернутьТекстВHTML(Текст) Экспорт
	
	Текст = "
	|<html>
	|<head>
	|<style>
	|* html body {
	|  behavior:/*url(""csshover.htc"");  IE6: http://www.xs4all.nl/~peterned/csshover.html */
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
    |" + Текст + "
	|</body>
	|</html>";
	
КонецПроцедуры
Процедура Tree01_ДобавитьСкриптВHTML(Текст) Экспорт
	
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
	|";
	
КонецПроцедуры

Процедура ДобавитьДеревоПоСтруктурам(Текст, Структура)
	
	Для Каждого Элемент Из Структура Цикл
		
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") ИЛИ  ТипЗнч(Элемент.Значение) = Тип("Соответствие") Тогда	// узел дерева
			
			Текст = Текст + "
			|<li>" + Элемент.Ключ + "<ul>";
			
			ДобавитьДеревоПоСтруктурам(Текст, Элемент.Значение);
			
			Текст = Текст + "
			|</ul></li>" + Элемент.Ключ;
			
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Массив") Тогда        // массив нижних уровней
			
			Текст = Текст + "
				|<li>" + Элемент.Ключ + ":</li><ul>";
			
			Для Каждого ЭлМассива Из Элемент.Значение Цикл
				
				Текст = Текст + "
				|<li>" + ЭлМассива + "</li>";
				
			КонецЦикла;
			
			Текст = Текст + "</ul>"
			
		Иначе															// нижний уровень
			
			Текст = Текст + "
			|<li>" + Элемент.Ключ + ": " + Элемент.Значение + "</li>";
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
Функция Tree01_ПолучитьHTMLПоТексту(Текст) Экспорт
	
	Текст ="
	|<ul class=""tree"">
	|" + Текст + "
	|</ul>
    |";
	
	Tree01_ДобавитьСкриптВHTML(Текст);
	Tree01_ЗавернутьТекстВHTML(Текст);
	
	Возврат Текст;
	
КонецФункции
Функция Tree01_ПолучитьHTMLПоСтруктуре(Структура) Экспорт

	// Структура - тип структура или соотвтетвие
	// 		элементами могут быть обычные объекты преобразованные к строке
	//		также структуры или сооствествия, тогда это элемент дерева
	//		также массивом
	
	Текст = "";
	ДобавитьДеревоПоСтруктурам(Текст, Структура);
	
	Возврат Tree01_ПолучитьHTMLПоТексту(Tree01_ПолучитьHTMLПоТексту(Текст));
	
КонецФункции