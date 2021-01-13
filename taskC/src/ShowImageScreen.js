import React from 'react';
import { View, ScrollView,TouchableOpacity, SafeAreaView, Text, Image, StyleSheet } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

const imgData = [
  require('./assets/img/Display/d1.jpg'),
  require('./assets/img/Display/d2.jpg'),
  require('./assets/img/Display/d3.jpg'),
  require('./assets/img/Display/d4.jpg'),
  require('./assets/img/Display/d5.jpg'),
  require('./assets/img/Display/d6.jpg'),
  require('./assets/img/Display/d7.jpg'),
  require('./assets/img/Display/d8.jpg'),
  require('./assets/img/Display/d9.jpg'),
  require('./assets/img/Display/d10.jpg'),
]

const ShowImageScreen = ({ navigation, route }) => {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View style={{ flex: 1, backgroundColor: 'white' }}>
        <ScrollView keyboardShouldPersistTaps="handled">
          {imgData.map((item, i) => 
            <TouchableOpacity style={styles.container}  onPress={async () => {
              await AsyncStorage.setItem('imageUri', i.toString());
              route.params.onGoBack();
              navigation.goBack();
            }}>
              <Image style={styles.previewImg} source={item} />
              <Text>{i+1}</Text>
            </TouchableOpacity>
           )}
        </ScrollView>
      </View>
    </SafeAreaView>
  );
};

export default ShowImageScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#ecf0f1',
  },
  text: {
    color: '#111825',
    fontSize: 18,
    marginTop: 16,
    marginLeft: 35,
    marginRight: 35,
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
  button: {
    alignItems: 'center',
    backgroundColor: '#f05555',
    color: '#ffffff',
    padding: 10,
    marginTop: 16,
    marginLeft: 35,
    marginRight: 35,
  },
  buttontext: {
    color: '#ffffff',
  },
  previewImg: {
    width: 150,
    height: 150,
    borderWidth: 2,
    borderColor: "gray"

  },
  logo: {
    width: 66,
    height: 58,
  },
});