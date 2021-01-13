import React, { useEffect, useState } from 'react';
import { View, KeyboardAvoidingView, TextInput, TouchableOpacity, SafeAreaView, Text, Image, StyleSheet } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as SQLite from 'expo-sqlite';
import { getImg } from './actions/index';
import { connect } from 'react-redux';

const STORAGE_USER_KEY = '@userInfo'

const ProductPostScreen = ({ navigation, getImg, imgData }) => {

  useEffect(() => {
    getImg();
    readData();
  }, [])

  const [userId, setUserId] = useState(0);
  const [imageUri, setImageUri] = useState(0);
  const [description, setDescText] = useState('');

  const readData = async () => {
    try {
      const userId = await AsyncStorage.getItem(STORAGE_USER_KEY)
      setUserId(userId);
      console.log("userId ddd", userId)
    } catch (e) { }
  }

  const onsubmit = () => {
    if(description == ''){
      alert('Please fill description')
    } else {
      const db = SQLite.openDatabase('ads.db');
    db.transaction(tx => {
      tx.executeSql(
        'CREATE TABLE IF NOT EXISTS ads (id INTEGER PRIMARY KEY AUTOINCREMENT, imgId int, description text, userId int)',
        [],
        (trans, result) => {
          console.log("create table result", result)
        },
        (error) => console.log("create table error fetching", error)
      );
      tx.executeSql(
        "insert into ads (imgId, description, userId) values (?, ?, ?)",
        [imageUri, description, userId],
        (trans, result) => {
          console.log("insert data result", result)
        },
        (error) => console.log("insert data error fetching", error)
      );
    })
    navigation.navigate('ProductHome')
    }
  }

  const onGetImage = async () => {
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
            />
          </View>
          <TouchableOpacity style={styles.button} onPress={() => onsubmit(imageUri, description)} >
            <Text style={styles.text}>P O S T</Text>
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

export default connect(mapStateToProps, mapDispatchToProps)(ProductPostScreen)

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