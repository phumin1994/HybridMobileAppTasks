//Show start page

import React from 'react';
import { SafeAreaView, StyleSheet, Text, TouchableOpacity } from 'react-native';

function StartScreen({ navigation }) {
  return (
    <SafeAreaView style={styles.container}>
      {/* when clicked button(TouchableOpacity), go to Categories page (Navigation) */}
      <TouchableOpacity onPress={() => navigation.navigate('Categories')}
        style={styles.button}>
          <Text style={styles.text}>Start</Text>
      </TouchableOpacity>
    </SafeAreaView>
  );
}
export default StartScreen;


const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    marginLeft: 100,
  },
  button: {
      borderRadius: 30,
      borderBottomWidth: 1,
      borderBottomColor: "gray",
      padding: 0,
      width: 150,
  },
  text: {
      fontSize: 40,
      textAlign: "center"
  }
});
