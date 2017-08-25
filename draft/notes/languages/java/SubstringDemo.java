/* Допустим, что существует метод issubstring, проверяющий, является
 * ли одно слово подстрокой другого. Для двух строк, s1 и s2, напишите
 * код проверки, получена ли строка s2 циклическим сдвигом s1,
 * используя только один вызов метода isSubstring (пример: слово
 * waterbottle получено циклическим сдвигом erbottlewat). 
 */

/* Если s2 -- циклический сдвиг s1, то можно найти точку
 "поворота". При сдвиге s1 делится на две части: x и y, которые в
 другом порядке сохраняются в s2.

  s1 = xy = waterbottle
  x = wat
  y = erbottle
  s2 = yx = erbottlewat

  Таким образом, необходимо проверить, существует ли вариант разбиения
  s1 на x и y, такой, что xy = s1, а yx = s2. Независимо от точки
  разделения x и y, yx всегда будет подстрокой xyxy. Таким образом, s2
  всегда будет подстрокой s1s1.
*/

class SubstringDemo {
    public boolean isRotation(String s1, String s2) {
	int len = s1.length();
	if (len == s2.length() && len > 0) {
	    String s1s1 = s1 + s1;
	    return isSubstring(s1s1, s2);
	}
        return false;
    }

    public static void main(String [] args) {
        String s1 = "waterbottle";
	String s2 = "erbottlewat";

	System.out.println(isRotation(s1, s2));
    }
}
