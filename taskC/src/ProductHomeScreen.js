import React, { useLayoutEffect, useState, useEffect, useRef } from 'react';
import { Animated, View, Text, SafeAreaView, TouchableOpacity, StyleSheet } from 'react-native';
import { CommonActions } from '@react-navigation/native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useDispatch } from "react-redux";

const STORAGE_CHECK_KEY = '@isChecked'
const STORAGE_USER_KEY = '@userInfo'

const ProductHomeScreen = ({ navigation }) => {
    const dispatch = useDispatch();
    const [userId, setUserId] = useState(0);

    useEffect(() => {
        readData();
        fadeIn();

    }, []);
     
    const fadeAnim = useRef(new Animated.Value(0)).current;

    const fadeIn = () => {
        // Will change fadeAnim value to 1 in 5 seconds
        Animated.timing(fadeAnim, {
            toValue: 1,
            duration: 5000,
        }).start();
    };

    useLayoutEffect(() => {
        navigation.setOptions({
            headerRight: () => (
                <TouchableOpacity
                    style={styles.logoutBtn}
                    onPress={onLogout}
                >
                    <Text style={styles.logoutBtnLabel}>Logout</Text>
                </TouchableOpacity>
            ),
        });
    }, [navigation]);

    const readData = async () => {
        try {
            const userId = await AsyncStorage.getItem(STORAGE_USER_KEY);
            console.log("userId", userId)
            setUserId(userId);
        } catch (e) {
        }
    }

    const onLogout = () => {
        saveData('release')
        navigation.dispatch(
            CommonActions.reset({
                index: 1,
                routes: [
                    { name: 'Login' },
                ],
            })
        );
    }
    const saveData = async (dataArray) => {
        try {
            await AsyncStorage.setItem(STORAGE_CHECK_KEY, JSON.stringify(dataArray))
            console.log("saving", dataArray)
        } catch (e) {
            alert('Failed to save the data to the storage')
        }
    }
    return (
        <SafeAreaView style={{ flex: 1, backgroundColor: 'white', paddingTop: 0 }}>
            <View style={styles.container}>
                <Animated.View
                    style={[
                        styles.fadingContainer,
                        {
                            opacity: fadeAnim, // Bind opacity to animated value
                        },
                    ]}>
                    <Text style={styles.welcome}>WELCOME!</Text>
                </Animated.View>
            </View>
            <View style={{ flex: 1 }}>
                <View style={{ flex: 1 }}>
                    <TouchableOpacity style={styles.button} onPress={
                        () => {
                            dispatch({type: 'GET_IMG'})
                            navigation.navigate('ProductPost')}
                        }>
                        <Text style={styles.text}>Post Ads</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.button} onPress={() => navigation.navigate('ProductViewMy', { userId })}>
                        <Text style={styles.text}>View My Ads</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.button} onPress={() => navigation.navigate('ProductViewAll')}>
                        <Text style={styles.text}>View All Ads</Text>
                    </TouchableOpacity>
                </View>
            </View>
        </SafeAreaView>
    );
};

export default ProductHomeScreen;

const styles = StyleSheet.create({
    text: {
        color: 'black',
        fontSize: 20,
        marginLeft: 35,
        marginRight: 35,
    },
    button: {
        alignItems: 'center',
        backgroundColor: '#00bfff',
        padding: 10,
        marginTop: 25,
        marginLeft: 35,
        marginRight: 35,
        color: '#ffffff',
        borderRadius: 5,
    },
    logoutBtn: {
        marginRight: 15,
    },
    welcome: {
        textAlign: 'center', 
        fontSize: 30, 
        backgroundColor: 'gray', 
        color: 'white', 
        padding: 15},
});
