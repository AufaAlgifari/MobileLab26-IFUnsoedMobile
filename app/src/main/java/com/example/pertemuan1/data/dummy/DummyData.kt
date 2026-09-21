package com.example.pertemuan1.data.dummy

import com.example.pertemuan1.data.model.Category
import com.example.pertemuan1.data.model.Product

object DummyData {
    val categories = listOf(
        Category(id = 1, name = "Makanan", description = "Aneka Makanan Lokal", products_count = 5),
        Category(id = 2, name = "Minuman", description = "Minuman Segar", products_count = 5),
        Category(id = 3, name = "Kerajinan", description = "Kerajinan Tangan", products_count = 5)
    )

    val products = listOf(
        // Makanan
        Product(id = 1, category_id = 1, category = categories[0], name = "Kripik Singkong", description = "Kripik gurih", price = 15000.0, stock = 30, img = "dummy_product"),
        Product(id = 2, category_id = 1, category = categories[0], name = "Mendoan", description = "Tempe mendoan tradisional", price = 20000.0, stock = 25, img = "dummy_product"),
        Product(id = 3, category_id = 1, category = categories[0], name = "Sale Pisang", description = "Manis legit", price = 25000.0, stock = 20, img = "dummy_product"),
        Product(id = 4, category_id = 1, category = categories[0], name = "Getuk Goreng", description = "Getuk khas Sokaraja", price = 30000.0, stock = 40, img = "dummy_product"),
        Product(id = 5, category_id = 1, category = categories[0], name = "Nopia", description = "Kue tradisional Banyumas", price = 35000.0, stock = 15, img = "dummy_product"),

        // Minuman
        Product(id = 6, category_id = 2, category = categories[1], name = "Teh Poci", description = "Wangi sepet", price = 10000.0, stock = 50, img = "dummy_product"),
        Product(id = 7, category_id = 2, category = categories[1], name = "Es Dawet", description = "Dawet ayu khas banjarnegara", price = 15000.0, stock = 35, img = "dummy_product"),
        Product(id = 8, category_id = 2, category = categories[1], name = "Wedang Jahe", description = "Hangat jahe pilihan", price = 12000.0, stock = 20, img = "dummy_product"),
        Product(id = 9, category_id = 2, category = categories[1], name = "Es Duren", description = "Segar manis", price = 25000.0, stock = 10, img = "dummy_product"),
        Product(id = 10, category_id = 2, category = categories[1], name = "Jamu Beras Kencur", description = "Sehat tradisional", price = 8000.0, stock = 30, img = "dummy_product"),

        // Kerajinan
        Product(id = 11, category_id = 3, category = categories[2], name = "Sapu Glagah", description = "Khas purbalingga", price = 25000.0, stock = 15, img = "dummy_product"),
        Product(id = 12, category_id = 3, category = categories[2], name = "Batik Banyumasan", description = "Motif khas", price = 150000.0, stock = 10, img = "dummy_product"),
        Product(id = 13, category_id = 3, category = categories[2], name = "Tas Pletok", description = "Tas bambu", price = 75000.0, stock = 12, img = "dummy_product"),
        Product(id = 14, category_id = 3, category = categories[2], name = "Kerajinan Bambu", description = "Peralatan rumah tangga", price = 50000.0, stock = 8, img = "dummy_product"),
        Product(id = 15, category_id = 3, category = categories[2], name = "Cap Gelebeg", description = "Kain tenun tradisional", price = 120000.0, stock = 5, img = "dummy_product")
    )
}