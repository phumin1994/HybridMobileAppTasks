class Orders {
  String orderid,
      deliveryboyid,
      orderaddress,
      orderamount,
      orderstatus,
      user_id,
      customer_name;

  Orders(
      String orderid,
      String deliveryboyid,
      String orderaddress,
      String orderamount,
      String orderstatus,
      String user_id,
      String customer_name) {
    this.deliveryboyid = deliveryboyid;
    this.orderid = orderid;
    this.orderaddress = orderaddress;
    this.orderamount = orderamount;
    this.orderstatus = orderstatus;
    this.user_id = user_id;
    this.customer_name = customer_name;
  }
}
