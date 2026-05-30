using {
    cuid,
    managed,
    sap.common.Currencies

} from '@sap/cds/common';
using {Attachments} from '@cap-js/attachments';


namespace tutorial.db;

/*
İnal
*/
entity Books : cuid, managed {

    title       : String;
    author      : Association to Authors;
    genre       : Association to Genres;
    publishedAT : Date;
    pages       : Integer;
    price       : Decimal(9, 2);
    currency    : Association to Currencies;
    stock       : Integer;
    status      : Association to BookStatus;
    chapters    : Composition of many Chapters
                      on chapters.book = $self;
/*
Bu Book’un bölümleri var ve bu bölümler Book’a bağlıdır.
Bu da bağlantı şartı:

Chapters tablosundaki book alanı, şu anki Book’u gösteriyorsa o chapter bu kitaba aittir.

$self = “şu an içinde bulunduğum Book kaydı”.
Kitap ana varlık, chapter onun çocuğu gibi.
*/


}

entity Genres {
    key code        : String;
        description : String;
}

entity BookStatus {
    key code        : String(1) enum {
            Available = 'A';
            Low_Stock = 'L';
            Unavailable = 'U';
        }
        criticality : Integer;
        displayText : String;
}


entity Authors : cuid, managed {
    name              : String;
    filename          : String;
    filetype          : String @Core.IsMediaType;

    virtual bookCount : Integer;
    attachments       : Composition of many Attachments;

    @Core.MediaType                  : filetype
    @Core.AcceptableMediaTypes       : [
        'application/pdf',
        'image/jpeg',
        'image/png'
    ]
    @Core.ContentDisposition.Filename: filename
    content           : LargeBinary;

    books             : Association to many Books
                            on books.author = $self;
}


entity Chapters : cuid, managed {
    key book   : Association to Books;
        number : Integer;
        title  : String;
        pages  : Integer;
}
