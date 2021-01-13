
import React, { useState, useEffect} from 'react';
import { Alert, Text, Button, TouchableOpacity, TextInput, View, StyleSheet, CheckBox } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as SQLite from 'expo-sqlite';
import { CommonActions } from '@react-navigation/native';
// async storage key name
const STORAGE_USER_KEY = '@userInfo'
const STORAGE_ISCHECKED_KEY = '@isChecked'

function LoginScreen({ navigation }) {

  useEffect(() => {   
    const db = SQLite.openDatabase('ads.db');
    db.transaction(tx => {
      tx.executeSql(
        "select * from user",
        [],
        (trans, result) => {
          setUserList(result.rows['_array']);
        },
        (error) => console.log("userData error fetching", error)
      );
    })
    readData()
  }, [])

  const saveData = async (storage, dataArray) => {
    try {
      await AsyncStorage.setItem(storage, JSON.stringify(dataArray))
      console.log("saving", storage, dataArray)
      // alert('Data successfully saved')
    } catch (e) {
      alert('Failed to save the data to the storage')
    }
  }

  const readData = async () => {
    try {
      const isChecked = await AsyncStorage.getItem(STORAGE_ISCHECKED_KEY)
      const userInfo = await AsyncStorage.getItem(STORAGE_USER_KEY)
      const temp = "checked"
      if (isChecked.includes(temp)) {
        console.log("isChecked if clause", isChecked)
        navigation.dispatch(
          CommonActions.reset({
            index: 1,
            routes: [
              { name: 'ProductHome' },
            ],
          })
        );
      } 
    } catch (e) {      
    }
  }

  const [isSelected, setSelection] = useState(false);
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [userList, setUserList] = useState([]);
  const onLogin = () => {
    if(username == ''){
      alert("please fill user name")
    } else if (password == ''){
      alert("please fill user password")
    } else{
      const filterUser = userList.filter( element => element.name === username && element.password === password)
      if (filterUser.length == 0){
        Alert.alert('Wrong credential!', 'try again');
      } else{
        saveData(STORAGE_USER_KEY, filterUser[0].id);
        if(isSelected){
          saveData(STORAGE_ISCHECKED_KEY, 'checked')
        } 
        navigation.dispatch(
          CommonActions.reset({
            index: 1,
            routes: [
              { name: 'ProductHome' },
            ],
          })
        );
      } 
    }
      
  };

  return (
    <View style={styles.container}>
      <TextInput
        value={username}
        onChangeText={(username) => setUsername(username)}
        placeholder={'Username'}
        style={styles.input}
      />
      <TextInput
        value={password}
        onChangeText={(password) => setPassword(password)}
        placeholder={'Password'}
        secureTextEntry={true}
        style={styles.input}
      />
      <View style={styles.checkboxContainer}>
        <CheckBox
          value={isSelected}
          onValueChange={setSelection}
          style={styles.checkbox}
        />
        <Text style={styles.label}>Remember me on this device</Text>
      </View>
      <Button
        title={'Login'}
        style={styles.input}
        onPress={() => onLogin()}
      />
      <View style={styles.signup}>
        <Text>Don't you have account?</Text>
        <TouchableOpacity onPress={() => navigation.navigate('SignUp')}>
          <Text style={styles.signupButton}>  Sign up</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

export default LoginScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 50,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#ecf0f1',
  },
  input: {
    width: 200,
    height: 44,
    padding: 10,
    borderWidth: 1,
    borderColor: 'black',
    marginBottom: 10,
  },
  checkboxContainer: {
    flexDirection: "row",
    marginBottom: 20,
  },
  checkbox: {
    alignSelf: "center",
  },
  label: {
    margin: 8,
  },
  signup: {
    flex: 1,
    flexDirection: "row",
    justifyContent: "center"
  },
  signupButton: {
    color: "blue"
  }
});
