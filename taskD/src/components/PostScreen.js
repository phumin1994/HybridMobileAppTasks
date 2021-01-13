import React, { useEffect, useState } from 'react';
import { View, KeyboardAvoidingView, TextInput, ScrollView, TouchableOpacity, SafeAreaView, Text, Image, StyleSheet } from 'react-native';
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

const PostScreen = ({ navigation }) => {
    useEffect(() => {
        listenProducts();
    }, [])

    const [title, setTitle] = useState('');
    const [price, setPrice] = useState('');
    const [description, setDescription] = useState('');
    const [products, setProducts] = useState([]);

    const onsubmit = () => {
        if (title == '') {
            alert('Please fill title')
        } else if (price == '') {
            alert('Please fill price')
        } else if (description == '') {
            alert('Please fill description')
        }
        else {
            const newObj = { id: Date.now(), title: title, price: price, description: description }
            const newProduct = [...products, newObj]
            storeProducts(newProduct);
            navigation.navigate('Home')
        }
    }
    const storeProducts = (newProduct) => {
        firebase
            .database()
            .ref('products')
            .set({
                productList: newProduct
            });
    }
    const listenProducts = () => {
        firebase.database().ref('products').on('value', (snapshot) => {
            const productList = snapshot.val().productList;
            setProducts(productList);
        });
    }

    return (
        <SafeAreaView style={styles.container}>
            <View style={{ flex: 1 }}>
                <ScrollView keyboardShouldPersistTaps="handled">
                    <View style={styles.labelGroup}>
                        <Text style={styles.label}>Title :</Text>
                        <TextInput
                            style={styles.title}
                            onChangeText={
                                (title) => setTitle(title)
                            } />
                    </View>
                    <View style={styles.labelGroup}>
                        <Text style={styles.label}>Price :</Text>
                        <TextInput
                            style={styles.title}
                            onChangeText={
                                (price) => setPrice(price)
                            } />
                    </View>
                    <KeyboardAvoidingView>
                        <View >
                            <Text style={{ marginLeft: 15, marginTop: 30, fontSize: 20 }}>Description :</Text>
                            <TextInput style={styles.input}
                                underlineColorAndroid="transparent"
                                placeholder="Enter Description"
                                placeholderTextColor="gray"
                                onChangeText={
                                    (description) => setDescription(description)
                                }
                                numberOfLines={7}
                                multiline={true}
                            />
                        </View>
                        <TouchableOpacity style={styles.button} onPress={() => onsubmit()} >
                            <Text style={styles.text}>P O S T</Text>
                        </TouchableOpacity>
                    </KeyboardAvoidingView>
                </ScrollView>
            </View>
        </SafeAreaView>
    );
};

export default PostScreen;

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    text: {
        color: 'white',
        fontSize: 20,
        fontWeight: "900"
    },
    input: {
        marginLeft: 25,
        marginRight: 25,
        marginTop: 5,
        borderColor: 'gray',
        borderWidth: 1,
        textAlignVertical: 'top',
        padding: 10,
        fontSize: 20,
        color: "black"
    },
    button: {
        alignItems: 'center',
        backgroundColor: '#00bfff',
        padding: 10,
        marginTop: 15,
        marginLeft: 35,
        marginRight: 35,
        borderRadius: 5
    },
    previewImg: {
        marginTop: 0,
        marginLeft: 30,
        marginRight: 30,
        height: 150,
        width: 200,
        borderWidth: 3,
        borderColor: "#ff8833",
        alignSelf: 'center',
    },
    labelGroup: {
        flex: 1,
        marginTop: 30,
        flexDirection: 'row',
        justifyContent: 'space-around'
    },
    title: {
        borderBottomWidth: 1,
        marginTop: 10,
        height: 20,
        width: 250,
        fontSize: 20
    },
    label: {
        fontSize: 20,
        marginTop: 5,
        padding: 0,
        textAlignVertical: 'center'
    }
});