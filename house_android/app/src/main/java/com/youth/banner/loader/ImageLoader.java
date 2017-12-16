package com.youth.banner.loader;

import android.content.Context;
import android.graphics.Bitmap;
import android.widget.ImageView;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;

import net.lhh.apst.advancedpagerslidingtabstrip.R;


public  class ImageLoader implements ImageLoaderInterface<ImageView> {

    @Override
    public ImageView createImageView(Context context) {
        ImageView imageView = new ImageView(context);
        return imageView;
    }

    @Override
    public void displayImage(Context context, Object path, ImageView imageView) {
        RequestQueue mQueue = Volley.newRequestQueue(context);

        com.android.volley.toolbox.ImageLoader imageLoader = new com.android.volley.toolbox.ImageLoader(mQueue, new com.android.volley.toolbox.ImageLoader.ImageCache() {
            @Override
            public Bitmap getBitmap(String url) {
                return null;
            }

            @Override
            public void putBitmap(String url, Bitmap bitmap) {

            }
        });

        com.android.volley.toolbox.ImageLoader.ImageListener listener = com.android.volley.toolbox.ImageLoader.getImageListener(imageView, R.mipmap.home_house_default, R.mipmap.home_house_default);
        imageLoader.get((String)path, listener);
    }
}
