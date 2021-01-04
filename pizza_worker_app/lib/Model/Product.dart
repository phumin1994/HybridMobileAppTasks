class Product {
  String productid,image, veg_non_veg, category_id, price, name, description,quantity;

  Product(String productid,String image, String veg_non_veg, String category_id, price,
      String name, String description,String quantity) {
    this.veg_non_veg = veg_non_veg;
    this.productid=productid;
    this.category_id = category_id;
    this.image=image;
    this.price = price;
    this.name = name;
    this.description = description;
    this.quantity=quantity;
  }
}
