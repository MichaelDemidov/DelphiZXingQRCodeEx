Changelog 
=========

All changes listed here are given in comparison with the original project DelphiZXingQRCode from Debenu (see README.md).

## 1. Support for non-standard programmer-defined encodings ##

Although the QR Code standard claims a list of possible encodings, sometimes a programmer needs to add something special.
For example, Sberbank of Russia recommends using Win-1251 or KOI-8 encodings that are not provided by the standard.
Or it would be convenient to implement the ability to encode URL-addresses containing non-Latin characters (which are
usually replaced with the % sign and UTF-8 code). Some code changes were made to support such non-standard encoding ways:

1. *TEncoder* class and everything related has been moved from the *implementation* section of *DelphiZXIngQRCode*
unit into *interface*.
2. Three methods of *TEncoder* class (*ChooseMode*, *FilterContent*, *AppendBytes*) have been moved into the
*protected* section and have become virtual. Now a programmer is able to add his own encoding classes as *TEncoder*
descendants. The following items in this list are the result of this.
3. Enumerated type *TQRCodeEncoding* is replaced by a set of integer constants *ENCODING_…* The class
*TDelphiZXingQRCode* has a new method *RegisterEncoder*. So after creating a *TEncoder* descendant, a programmer
can define it as a standard encoder for the new character set (or even for the old one if needed). The new method
*GetEncoderClass* provides information about any registered encoder.
4. The new *TDelphiZXingQRCode* class property *FilteredData* contains a string that is actually written in the QR Code
(useful for self-control as the input string is converted by the encoder, and the input data may differ from
the recorded one). *TEncoder* class' method *Encode* was upgraded. It now returns this string.
5. The global function *GenerateQRCode* has been removed. All of its functionality is now implemented inside the
*TDelphiZXingQRCode* class (*Update* method, which has made *public*). This simplifies the encoders management.
6. Examples of programmer-defined encoders have been added:  *TWin1251Encoder* (Win-1251 encoding) in
*QR\_Win1251.pas* and *TURLEncoder* (URL with non-Latin characters) in *QR\_URL.pas*.

## 2. Error correction level ##

It actually existed in the original library ZXing, but had been incorrectly ported to Delphi. It is strange that
after a year the authors have not corrected this bug themselves.

1. Property *TDelphiZXingQRCode.ErrorCorrectionOrdinal* has been added. It has the enumerated type related to four
levels of error correction (L, M, H, Q).
2. Class *TErrorCorrectionLevel* has been rewritten.

## 3. Exception handling ##

DelphiZXingQRCode doesn't contain a lot of exception handling. For example, if the input string exceeds the maximum possible
length defined by the QR Code standard, Access Violation is raised. I think this behavior is not correct, and I added
exception class *EQRMatrixTooLarge*.

## 4. Other new properties, methods, and events for *TDelphiZXingQRCode* class ##

1. *BeforeUpdate* and *AfterUpdate* events have been added to *TDelphiZXingQRCode* class. They are called before and
after QR Code generation, accordingly. The first one allows, for example, to check input string, and the second can
refresh the on-screen image.
2. Methods *BeginUpdate* and *EndUpdate* have been added to temporarily lock QR Code updates when property values
change.

## 5. Minor bug fixes, refactoring, and other improvements ##

* Many refactorings have been done to improve the source code readability. Redundant parentheses after *if* and
unneeded *begin / end* pairs around single line have been removed, etc.

-------------------------

**Example**

before:

<pre><code>if (I = 1) then
begin
    Exit;    
end;
</code></pre>

after:

<pre><code>if I = 1 then
    Exit;
</code></pre>

-------------------------

The biggest example was this: 40 sequential *if … then … else if … then … else* constructs have been replaced with single
*case*.

Thus the total source code has been shortened by more than 200 lines, despite the addition of properties, methods, and other
(see above).

* Empty *if / then* and *try / except* blocks have been corrected (code fragments that were supposed to be inside, were
located outside these blocks).
 
* Empty class *TCharacterSetECI* definition has been removed.

* There was some confusion in the structure of classes (*private / public / protected* fields, methods, and properties).
Corrected.
 
* Class *TMaskUtil* has been removed. It contained one single method (*GetDataMaskBit*) that was used in one place.
This method was placed there. Function *GetModeBits* was deleted because it contained a single line of 
code, which I put in the right place.

* Class *TECB* has been replaced by a record type because it only contained a pair of fields and methods 
to read them. Useless thing, I think.

* Some explanatory comments have been added in those places where something was particularly unclear.

* …maybe something else that I forgot.

## 6. Unit *QRGraphics.pas* ##

In DelphiZXingQRCode there was no code to create an image from the QR Code. Only a demo application could generate a simple bitmap.
I think that it is not enough.

*QRGraphics.pas* unit contains several functions to draw the QR Code on a given canvas (*TCanvas*) and to generate either
a bitmap or a metafile.

A little bonus: there is a code in the demo application that saves the image in JPEG format (see *btnSaveToFile.OnClick* handler).

## 7. Demo application *TestApp* ##

This program is so altered that it can be considered as created from scratch. In fact, it is now possible to use it as
a standalone application to generate different QR Codes. It also can save the image to BMP, EMF, or JPEG files.
