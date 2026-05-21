import cds from '@sap/cds'
import { Books } from '#cds-models/BookstoreService'

export default class BookstoreService extends cds.ApplicationService {
  async init() {
    // Books entity'si için addStock action'ı çalışınca tetiklenir
    // Kullanıcının işlem yaptığı kitabın ID'sini alıyoruz.
    // Bound action olduğu için ID bilgisi req.params[0].ID içinden gelir.
    this.on('addStock', Books, async (req) => {
      const bookId = req.params[0].ID
      await UPDATE(Books).set({ stock: { '+=': 1 } }).where({ ID: bookId })
      // Action'ın çalıştığı kitabın ID bilgisini alır
      // İlgili kitabın stock değerini 1 artırır
    })

this.on('changePublishDate', Books, async (req) => {
  const bookId = req.params[0].ID
  const newDate = req.data['newDate']

  await UPDATE(Books)
    .set({ publishedAT: newDate })
    .where({ ID: bookId })
})

this.on('changeStatus', Books, async (req) => {
  const bookId = req.params[0].ID
  const newStatus = req.data['newStatus']

  await UPDATE(Books)
    .set({ status_code: newStatus })
    .where({ ID: bookId })
})

    this.before('READ', Books, async (req) => {
      console.log('Before READ Books')
    })

    this.on('READ', Books, async (req, next) => {
      console.log('On EVENT')
      return next()
    })

    this.after('READ', Books, async (books, req) => {
      for (const book of books) {
        if (book.genre_code === 'Art') {
          book.price = book.price * 0.8
        }
      }
    })

    return super.init()
  }
}