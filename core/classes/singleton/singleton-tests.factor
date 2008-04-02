USING: kernel classes.singleton tools.test prettyprint io.streams.string ;
IN: classes.singleton.tests

[ ] [ SINGLETON: bzzt ] unit-test
[ t ] [ bzzt bzzt? ] unit-test
[ t ] [ bzzt bzzt eq? ] unit-test
GENERIC: zammo ( obj -- str )
[ ] [ M: bzzt zammo drop "yes!" ; ] unit-test
[ "yes!" ] [ bzzt zammo ] unit-test
[ ] [ SINGLETON: omg ] unit-test
[ t ] [ omg singleton? ] unit-test
[ "IN: classes.singleton.tests\nSINGLETON: omg\n" ] [ [ omg see ] with-string-writer ] unit-test
