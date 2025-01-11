/*
IOS Theos Template Komaru
Jailed (NoJB) Mod Menu Template for iOS Games
By aq9
https://github.com/VenerableCode/iOS-Theos-ModMenuTemp-NoJB
*/

#include "BasicHacks.h"
#include "../MenuLoad/Includes.h"

bool running = true;

namespace offsets {
    constexpr uintptr_t OFFSET_GWorld                   = 0x04d5b510;
    constexpr uintptr_t OFFSET_OwningGameInstance       = 0x320;
    constexpr uintptr_t OFFSET_LocalPlayers             = 0x38;
    constexpr uintptr_t OFFSET_LocalPlayerController    = 0x30;
    constexpr uintptr_t OFFSET_PlayerCameraManager      = 0x480;
}

void* BasicHacks::HacksThread(void* arg)
{

    while(running)
    {   
        using namespace offsets;

        usleep(100);
        //ARK FOV Changer example
        uintptr_t BaseAddr                =  (uintptr_t)_dyld_get_image_header(0);
        uintptr_t GWorld                  = KomaruPatch::ReadMem(BaseAddr + OFFSET_GWorld);
        uintptr_t OwningGameInstance      = KomaruPatch::ReadMem(GWorld + OFFSET_OwningGameInstance);
        uintptr_t LocalPlayers            = KomaruPatch::ReadMem(OwningGameInstance + OFFSET_LocalPlayers);
        uintptr_t LocalPlayer             = KomaruPatch::ReadMem(LocalPlayers);
        uintptr_t LocalPlayerController   = KomaruPatch::ReadMem(LocalPlayer + OFFSET_LocalPlayerController);
        uintptr_t PlayerCameraManager     = KomaruPatch::ReadMem(LocalPlayerController + OFFSET_PlayerCameraManager);

//      KomaruPatch::WriteMem<DType>(Ptr   + Offset, Value);
        KomaruPatch::WriteMem<float>(PlayerCameraManager + 0x33c0, KTempVars.CameraFOV); // MenuLoad -> Includes.h

    } return NULL; }


void BasicHacks::Initialize()
{
    pthread_t BasicHacksThread;
    pthread_create(&BasicHacksThread, nullptr, HacksThread, nullptr);
}
