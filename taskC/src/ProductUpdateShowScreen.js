import React, { useState, useEffect } from 'react';
import { View, KeyboardAvoidingView, TextInput, TouchableOpacity, SafeAreaView, Text, Image, StyleSheet } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as SQLite from 'expo-sqlite';
import { getImg } from './actions/index';
import { connect } from 'react-redux';

const ProductUpdateShowScreen = ({ navigation, route, getImg, imgData }) => {
    useEffect(() => {
        getImg();
      }, [])

    const { adsId, imgId, description } = route.params;

    const [imageUri, setImageUri] = useState(imgId);
    const [newDescription, setDescText] = useState(description);

    const onsubmit = () => {
        if (description == '') {
            alert('Please fill description')
        } else {
            const db = SQLite.openDatabase('ads.db');
            db.transaction(tx => {
                tx.executeSql(
                    'UPDATE ads SET imgId=?, description=? WHERE id = ?', 
                    [imageUri, newDescription, adsId],
                    (trans, result) => {
                        console.log("Update success!", result)
                    },
                    (error) => console.log("insert data error fetching", error)
                );
            })
            navigation.navigate('ProductHome')
        }
    }

    const onGetImage = async () => {
        console.log('aaaa');
        setImageUri(await AsyncStorage.getItem('imageUri'));
    }

    return (
        <SafeAreaView style={styles.container}>
            <View>
                <TouchableOpacity onPress={() => navigation.navigate('ShowImage', { onGoBack: () => onGetImage() })}>
                    <Image style={styles.previewImg} source={imgData[imageUri]} />
                </TouchableOpacity>
                <KeyboardAvoidingView>
                    <View>
                        <TextInput style={styles.input}
                            underlineColorAndroid="transparent"
                            placeholder="Enter Description"
                            placeholderTextColor="#007FFF"
                            onChangeText={
                                (description) => setDescText(description)
                            }
                            numberOfLines={7}
                            multiline={true}
                            value={newDescription}
                        />
                    </View>
                    <TouchableOpacity style={styles.button} onPress={() => onsubmit(imageUri, description, adsId)} >
                        <Text style={styles.text}>Update</Text>
                    </TouchableOpacity>
                </KeyboardAvoidingView>
            </View>
        </SafeAreaView>
    );
};

const mapStateToProps = state => ({
    imgData: state,
  });
  
  const mapDispatchToProps = dispatch => ({
    getImg
  });
  
  export default connect(mapStateToProps, mapDispatchToProps)(ProductUpdateShowScreen)
  
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
        marginLeft: 35,
        marginRight: 35,
        marginTop: 15,
        borderColor: 'gray',
        borderWidth: 2,
        textAlignVertical: 'top',
        padding: 10,
        fontSize: 16,
        color: "black"
    },
    button: {
        alignItems: 'center',
        backgroundColor: '#00bfff',
        padding: 10,
        marginTop: 25,
        marginLeft: 35,
        marginRight: 35,
    },
    previewImg: {
        marginTop: 20,
        marginLeft: 30,
        marginRight: 30,
        height: 150,
        width: 200,
        borderWidth: 3,
        borderColor: "#ff88ff",
        alignSelf: 'center',
    },
});