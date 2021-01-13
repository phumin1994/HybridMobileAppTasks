
import React, { useState} from 'react';
import { Alert, Text, Button, TouchableOpacity, TextInput, View, StyleSheet} from 'react-native';
import * as SQLite from 'expo-sqlite';
import { CommonActions } from '@react-navigation/native';


function SignupScreen({ navigation }) {
  
  const userRegister = () => {
    const db = SQLite.openDatabase('ads.db');
    db.transaction(tx => {
      tx.executeSql(
        'CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY AUTOINCREMENT, name text, password text)',
        [],
        (trans, result) => {
          console.log("create user table result", result)
        },
        (error) => console.log("create user table error fetching", error)
      );
      tx.executeSql(
        "insert into user (name, password) values (?, ?)",
        [username, password],
        (trans, result) => {
          console.log("insert user data result", result)
        },
        (error) => console.log("insert user data error fetching", error)
      );
      tx.executeSql(
        "select * from user",
        [],
        (trans, result) => {
          console.log("userData", result.rows['_array']);
        },
        (error) => console.log("userData error fetching", error)
      );
    })
  }

  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [repassword, setRepassword] = useState("");
  const onRegister = () => {
    if(username != '' && password != ''){
      if(password == repassword){
        userRegister(username, password)
        Alert.alert('Your name:' + username +', password:'+ password);
        setUsername('')
        setPassword('')
        setRepassword('')
        navigation.dispatch(
          CommonActions.reset({
            index: 1,
            routes: [
              { name: 'ProductHome' },
            ],
          })
        );
      } else{
        Alert.alert('confirm your password');
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
      <TextInput
        value={repassword}
        onChangeText={(repassword) => setRepassword(repassword)}
        placeholder={'Confirm Password'}
        secureTextEntry={true}
        style={styles.input}
      />
      <Button
        title={'Register'}
        style={styles.input}
        onPress={() => onRegister()}
      />
      <View style={styles.signup}>
        <Text>Do you have already account? </Text>
        <TouchableOpacity onPress={() => navigation.navigate('Login')}>
          <Text style={styles.signin}>Sign in</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

export default SignupScreen;

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
  signin: {
    color: "blue"
  }
});
