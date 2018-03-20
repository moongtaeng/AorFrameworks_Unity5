﻿using System;
using System.Collections.Generic;
using UnityEngine;

public class GraphicsSettingAsset : ScriptableObject
{

    public bool UseFixedUpdate = false;
    public bool AllowVCamParaCover = true;

    /// <summary>
    /// 主相机描述
    /// </summary>
    public GCamGDesInfo MainCamDesInfo;

    /// <summary>
    /// 子相机描述
    /// </summary>
    public List<GCamGDesInfo> SubCamGDesInfos;

}

public enum SubGCamType
{
    Normal,
    MainCamera,
    RenderTextureCombine,
    FinalOutput
}


//public class GCamGDesInfo : ScriptableObject
[Serializable]
public struct GCamGDesInfo
{

    public static GCamGDesInfo Default()
    {
        return new GCamGDesInfo("Uname", SubGCamType.Normal, string.Empty, 0);
    }

    public static GCamGDesInfo Main()
    {
        return new GCamGDesInfo("MainCamera", SubGCamType.MainCamera, "all", 0, GCLensSetting.Default());
    }

    public GCamGDesInfo(string name, SubGCamType type, string cullingMask, int depth)
    {
        this.init = true;
        this.name = name;
        this.type = type;
        this.cullingMask = cullingMask;
        this.depth = depth;
        this.lensSetting = new GCLensSetting();
    }

    public GCamGDesInfo(string name, SubGCamType type, string cullingMask, int depth, GCLensSetting lens)
    {
        this.init = true;
        this.name = name;
        this.type = type;
        this.cullingMask = cullingMask;
        this.depth = depth;
        this.lensSetting = lens;
    }

    public bool init;
    public string name;
    public SubGCamType type;
    public string cullingMask;
    public int depth;
    public GCLensSetting lensSetting;
}

[Serializable]
public struct GCLensSetting
{

    public static GCLensSetting Default()
    {
        return new GCLensSetting(CameraClearFlags.Skybox, Color.blue, false, 5, 60f, 0.3f, 1000f, true, true, true);
    }

    public GCLensSetting(CameraClearFlags ClearFlags, Color BackgroundColor,
        bool isOrthographicCamera, float OrthographicSize, float FieldOfView,
        float NearClipPlane, float FarClipPlane,
        bool UseOcclusionCulling, bool AllowHDR, bool AllowMSAA
        )
    {
        this.init = true;
        this.ClearFlags = ClearFlags;
        this.BackgroundColor = BackgroundColor;
        this.isOrthographicCamera = isOrthographicCamera;
        this.OrthographicSize = OrthographicSize;
        this.FieldOfView = FieldOfView;
        this.NearClipPlane = NearClipPlane;
        this.FarClipPlane = FarClipPlane;
        this.UseOcclusionCulling = UseOcclusionCulling;
        this.AllowHDR = AllowMSAA;
        this.AllowMSAA = AllowMSAA;
    }

    public bool init;
    public CameraClearFlags ClearFlags;
    public Color BackgroundColor;
    public bool isOrthographicCamera;
    public float OrthographicSize;
    public float FieldOfView;
    public float NearClipPlane;
    public float FarClipPlane;
    public bool UseOcclusionCulling;
    public bool AllowHDR;
    public bool AllowMSAA;
}