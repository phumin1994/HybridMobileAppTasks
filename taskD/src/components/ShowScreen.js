import React, { useEffect, useState } from 'react';
import { View, FlatList, TouchableOpacity, SafeAreaView, Text, StyleSheet, Alert } from 'react-native';
import * as firebase from 'firebase';

var firebaseConfig = {
  apiKey: "AIzaSyDojRnQa6Kt0A-nZgLYw2s_osSTMC2LwMI",
  authDomain: "task4-54e20.firebaseapp.com",
  projectId: "task4-54e20",
  storageBucket: "task4-54e20.appspot.com",
  messagingSenderId: "1026403446393",
  databaseURL: "https://task4-54e20-default-rtdb.firebaseio.com",
  appId: "1:1026403446393:web:25ec21968effa53315aea8",
  measurementId: "G-2Z6RZ9QXGM"
};
// Initialize Firebase
if (!firebase.apps.length) {
  firebase.initializeApp(firebaseConfig);
} else {
  firebase.app()
}

const ShowScreen = ({ navigation }) => {

  useEffect(() => {
    listenProducts();
  }, [])

  const [products, setProducts] = useState([]);
// read data from firebase
  const listenProducts = () => {
    firebase.database().ref('products').on('value', (snapshot) => {
      const productList = snapshot.val().productList;
      setProducts(productList);
    });
  }
  // store data to firebase
  const storeProducts = (newProduct) => {
    firebase
      .database()
      .ref('products')
      .set({
        productList: newProduct
      });
  }
 //delete data at firebase with id
  const deleteProduct = (id) => {
    Alert.alert(
      "Confirm",
      "Do you want to delete this Product?",
      [
        {
          text: "No",
          onPress: () => {
          },
          style: "cancel"
        },
        {
          text: "Yes", onPress: () => {
            firebase.database().ref('products').on('value', (snapshot) => {
              const productList = snapshot.val().productList;
              const newProductList = productList.filter(item => item.id != id);
              setProducts(newProductList);
              storeProducts(newProductList)
            });

          }
        }
      ],
      { cancelable: false }
    );
  }

  const renderItem = ({ item }) => (
    <Item
      productId={item.id}
      title={item.title}
      price={item.price}
      description={item.description}
      navigation={navigation} />
  );

  const Item = ({ title, description, price, productId }) => (
    <TouchableOpacity style={styles.productItem} onPress={() => navigation.navigate('UpdateShow', { productId, title, price, description })}>
      <View style={styles.flexContainer}>
        <View style={{ width: '90%' }}>
          <View style={styles.flexContainer}>
            <Text style={styles.title}>{title}</Text>
            <Text style={styles.price}>{price}</Text>
          </View>
          <Text style={styles.description}>{description}</Text>
        </View>
        <TouchableOpacity style={{ padding: 15, alignSelf: 'center' }} onPress={() => deleteProduct(productId)}>
          <Text style={styles.delete}>X</Text>
        </TouchableOpacity>
      </View>
    </TouchableOpacity>
  );
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View style={{ flex: 1, backgroundColor: 'white', }}>
        <FlatList
          data={products}
          renderItem={renderItem}
          keyExtractor={item => item.id.toString()}
        />
      </View>
    </SafeAreaView>
  );
};

export default ShowScreen;

const styles = StyleSheet.create({
  productItem: {
    flex: 1,
    flexDirection: "row",
    borderBottomWidth: 3,
    borderRadius: 15,
    borderBottomColor: "gray",
    paddingBottom: 5,
    paddingTop: 5,
  },
  flexContainer: {
    padding: 5,
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between'
  },
  description: {
    paddingLeft: 5,
    alignSelf: 'auto',
    fontSize: 18
  },
  title: {
    fontSize: 22,
    fontStyle: 'italic',
    color: 'blue'
  },
  price: {
    fontSize: 16,
    color: 'red'
  },
  delete: {
    fontSize: 20,
    borderWidth: 1,
    padding: 3,
    borderRadius: 10,
    color: 'black',
    backgroundColor: 'pink'
  }
});