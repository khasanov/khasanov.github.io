Java
====

final
-----

Ключевое слово final в Java меняет значение в зависимости от того, к
чему оно применяется: к переменной, классу или методу.

* Переменная
  Значение переменной не может быть изменено после инициализации.
* Метод
  Метод не может быть переопределен подклассом
* Класс
  Класс не может иметь подкласс.
  
finally
-------

Используется вместе с try/cach и гарантирует, что секция кода будет
выполнена, даже если произойдет исключительная ситуация.

public static String lem() {
    System.out.println("lem");
	return "возврат из lem";
}

public static String foo() {
    int x = 0;
	int y = 5;
	try {
	    System.out.println("запуск try");
		int b = y / x;
		System.out.println("завершение try");
		return "возврат из try";
	} catch (Exception ex) {
	    System.out.println("catch");
		return lem() + " | возврат из catch";
	} finally {
	    System.out.println("finally");
	}
}

public static void bar() {
    System.out.println("запуск bar");
	String v = foo();
	System.out.println(v);
	System.out.println("завершение bar");
}

public static void main(String[] args) {
    bar();
}

Будет выведено:
запуск bar
запуск try
catch
lem
finally
возврат из lem | возврат из catch
завершение bar


finalize()
----------

Сборщик мусора вызывает метод finalize() перед уничтожением
объекта. Класс может презаписать метод finalize(), чтобы определить
собственную процедуру уборки мусора.

protected void finalize() throws Throwable {
    /* закрываем файлы, освобождаем ресурсы и т.д. */
}


Перегрузка
----------

Термин, используемый для описания ситуации, когда два метода с одни
именем отличаются типами или количеством аргументов:

public double computeArea(Circle c) {...}
public double computeArea(Square s) {...}


Переопределение
---------------

Возникает, когда метод разделяет имя с функцией или другим методом в
суперклассе.


Java Collection Framework
-------------------------

### ArrayList ###
Массив с динамически изменяемым размером, он автоматически расширяется
при вставке новых элементов.

### Vector ###
похож на ArrayList, но является синхронизированным

### Linked List ###
Связный список
Используется для демонстрации синтаксиса итераторов.

### HashMap ###
