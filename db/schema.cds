using {
    cuid,
    managed
} from '@sap/cds/common';

namespace tutorial.db;

entity Books : cuid, managed {

    title    : String;
    author   : Association to Authors;
    chapters : Composition of Chapters
                   on chapters.book = $self;
/*
Bu Book’un bölümleri var ve bu bölümler Book’a bağlıdır.
Bu da bağlantı şartı:

Chapters tablosundaki book alanı, şu anki Book’u gösteriyorsa o chapter bu kitaba aittir.

$self = “şu an içinde bulunduğum Book kaydı”.
Kitap ana varlık, chapter onun çocuğu gibi.
*/


}


entity Authors : cuid, managed {
    name  : String;
    books : Association to many Books
                on books.author = $self;
}

entity Chapters : cuid, managed {
        number : Integer;
    key book   : Association to Books;
}
