DelphiZXingQRCodeEx
===================

DelphiZXingQRCodeEx is a Delphi port of the QR Code functionality from ZXing, an open source barcode image processing
library.

The code initially was ported to Delphi by Senior Debenu Developer, Kevin Newman (project *DelphiZXingQRCode,* see links
below). Then it was changed by Michael Demidov. The changes are listed in CHANGELOG.md.

**The most fundamental differences are:**

1. Error correction level has been fixed.
2. Support for programmer-defined charsets. As an example, I implemented Win-1251 Russian charset and URL encoding (when
non-Latin characters are represented as %-codes).
3. Exception handling has been added. There is no more Access Violation when input string is too long.
4. New *QRGraphics.pas* unit that contains several functions to draw the QR Code on a given canvas (*TCanvas*) and
to generate either a bitmap or a metafile.
5. Still compatible with older versions of Delphi (at least Delphi 7).

The port retains the original Apache License (v2.0).

# Links #

1. Original DelphiZXingQRCode project
  1. [Debenu site](http://www.debenu.com/open-source/delphizxingqrcode-open-source-delphi-qr-code-generator/)
  2. [GitHub Mirror](https://github.com/debenu/DelphiZXingQRCode/)
  3. [Fork at GitHub by Christian Budde](https://github.com/CWBudde/DelphiZXingQRCode), with some error corrections
(e.g. error correction level). Compatible with modern Delphi versions only (2005 and newer)
2. ZXing
  1. [Google Code](https://code.google.com/p/zxing/)
  2. [GitHub](https://github.com/zxing/zxing)
3. [Michael Demidov's blog](http://mik-demidov.blogspot.ru) (in Russian only, sorry)

# Software Requirements #

Delphi 7 or newer (may also work with older verions—I can't test).

# Getting Started #

A sample Delphi project is provided in the TestApp folder to demonstrate how to use DelphiZXingQRCode.