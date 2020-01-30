class TesseractTrainingTools < Formula
    desc "OCR (Optical Character Recognition) engine"
    homepage "https://github.com/tesseract-ocr/"
    url "https://github.com/tesseract-ocr/tesseract/archive/4.1.1.tar.gz"
    sha256 "2a66ff0d8595bff8f04032165e6c936389b1e5727c3ce5a27b3e059d218db1cb"
    revision 1
    head "https://github.com/tesseract-ocr/tesseract.git"
  
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  
    depends_on "leptonica"
    depends_on "libtiff"

    # training-tools dependancies
    depends_on "libtool" => :build
    depends_on "icu4c"
    depends_on "glib"
    depends_on "cairo"
    depends_on "pango"
    depends_on :x11
  
    def install
      # for training-tools
      icu4c = Formula["icu4c"]
      ENV.append "CFLAGS", "-I#{icu4c.opt_include}"
      ENV.append "LDFLAGS", "-L#{icu4c.opt_lib}"

      # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
      # which doesn't work for non-default homebrew location
      ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"
  
      ENV.cxx11
  
      system "./autogen.sh"
      system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--datarootdir=#{HOMEBREW_PREFIX}/share"

      # make training tools
      system "make", "training"

      # install training tools
      system "make", "training-install", "datarootdir=#{share}"
    end
  
    def caveats; <<~EOS
      This formula contains only the tesseract training tools.
      If you need tesseract please use, `brew install tesseract`.
    EOS
    end
  end