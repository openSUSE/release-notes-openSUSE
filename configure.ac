AC_INIT(release-notes-openSUSE, 13.2.0)
AC_SUBST(RN_DATE, 2013-12-10)
AC_CONFIG_SRCDIR([RELEASE-NOTES-openSUSE.xml])
AM_INIT_AUTOMAKE

# echo $PACKAGE_VERSION >version

AC_CHECK_PROG(XSLTPROC, xsltproc, xsltproc)
AC_CHECK_PROG(XMLLINT, xmllint, xmllint)
AC_CHECK_PROG(NSGMLS, nsgmls, nsgmls)
AC_CHECK_PROG(XML2PO, xml2po, xml2po)
AC_CHECK_PROG(MSGMERGE, msgmerge, msgmerge)
AC_CHECK_PROG(MSGCAT, msgcat, msgcat)

dnl required for txt output
AC_CHECK_PROG(W3M, w3m, w3m)
if test -z "$W3M"; then
  AC_MSG_ERROR([w3m not found])
fi

AC_PATH_PROG([FO2PDF], [fop])

AM_CONDITIONAL(ENABLE_REGENERATE_MAN, test x$enable_man != xno)
AM_CONDITIONAL(ENABLE_GENERATE_PDF, test ! -z "$FO2PDF")

AC_CONFIG_FILES([
Makefile
release-notes-openSUSE.spec
release-notes.ent
])
AC_OUTPUT
