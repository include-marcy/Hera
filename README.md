<p align="center">
  <img width="570" height="906" src="https://github.com/include-marcy/Hera/blob/0eb6fa3813328440bdf91eee3a85a459504ea9bd/assets/HeraTextLogoDarkMode.png?raw=true" />
</p>

<div align="center">

# What is Hera?
</div>
Hera is a Roblox UI Library and API (Application Program Interface) for Roblox Studio and its associated software. Hera is designed to empower applications to build fluid and world class interfaces easily and quickly. Hera overlaps with its sister plugin, the Hera Transit Designer, which allows artists to create and customize interface animations and sound design. Programmers need only be able to know how to download a file from their artist to instantly generate a stunning interface complete with responsive visual and audio features.

# Hera API Overview
To achieve this kind of workflow, Hera provides a host of objects that can be used to cleanly create and customize all of the afforementioned features.

The firstmost and primary abstraction is the `heraTransit`, which are syntactically similar to how `KeyframeSequence` and `Animation` classes work in Roblox Studio. A `.hera` file is generated by the artist's Hera Transit Designer plugin, which can be imported directly into the experience and loaded into a new `heraTransit`, so there are no asset ids or Roblox custom instances powering this UI audio-visual interface.

# Hera Transit API
A `heraTransit` is a Luau object that can be created from an exported `.hera` file. The `heraFileManager.luau` exposes exactly functionality needed to import a `heraTransit` from a `.hera` (.luau/.rbxm) file type.

# Hera Transit Designer
<p align="center">
  <img src="https://github.com/include-marcy/Hera/blob/0eb6fa3813328440bdf91eee3a85a459504ea9bd/assets/HeraTransitDesignerLogo.png?raw=true" />
</p>

<div align="center">

## Easy to learn, fun to master.
</div>

The Hera Transit Designer is a plugin that can be used to create, view, and edit `.hera` files. Artists who design their UI have the best understanding of how that interface should interact with and feel to the end user, and so the Hera Transit Designer is accessible and simple enough to learn that anyone could easily get it up and running in less than 5 minutes.

Hera Transit Designer is a fully fledged animation suite and development tool designed to be powerfully simple to use and especially smooth and functional. In this sense, Hera Transit Designer is capable of producing `KeyframeSequence` objects as well which can be exported and used in the Roblox animation system.

# Installing the Hera Transit Designer plugin
1. First, navigate to the plugin page on the Roblox Creator Store.
2. Next, obtain the plugin.
3. Open Roblox Studio, and navigate to the Toolbox.
4. Navigate to your personal Plugins, and select Hera Transit Designer vx.x.x (Whatever the highest number is)
5. Install the Hera Transit Designer, and navigate to the Plugins tab. You are now ready to use the Hera Transit Designer.

# Using the Hera Transit Designer plugin
- HTD (Hera Transit Designer) has several important tabs when it is booted up at first.

## Startup Menu
In no particular order, the following features are available upon immediately booting up the plugin (in the 'Startup Menu'):
1. Recent Projects - This menu shows the last 10 opened projects.
2. My Projects - This menu shows all available projects.
3. New Project - This widget will create a new, empty project.
4. My Settings - This menu contains configurable settings of the HTD plugin.

## Project View
The Project View is a menu that opens when editing a Project.
Inside the Project View, there are several tabs that each contain several buttons:
1. File - This tab meets demand for quick file editing. It contains the following sub-menus:
	- Add Object - This button will prompt you to select an existing GUI object to add to the Project.
	- New Object - This button will prompt you to create a new empty object, allowing you to configure a blank interface.
	- New Folder - This button will prompt you to create a new folder in the Project.
	- Save - This button will save the project state.
	- Save As - This button will save the project state to a new `.hera` file with the given name, discarding changes since the last save to the current `.hera` file.
	- Auto-Save - This button will toggle the Auto-Save feature.
	- Open Project - This button will prompt you to open another project.
	- Open Recent - This button will open a sub-tree directing to the recent projects.
	- Close - This button will close the current Project.
	- Close All - This button will close all open Projects, returning you to the Startup Menu.
2. Edit - This tab meets demand for shortcuts to the various Views.
3. Selection - This tab allows configurations and shortcuts for selecting various things pertaining to the current View.
4. View - This tab opens a sub-tree allowing you to select a View. The existing views are:
	- Dope Sheet - This view shows the keyframes in the Project over time. A keyframe describes the state of the UI at a certain point in time. The animator smoothly changes between these keyframes based on the distance between keyframes and the easing style of the keyframe.
	- Action Editor - This view shows the Action editor, allowing you to change between and place Actions on the Timeline. Actions allow you to repeat keyframe sequences multiple times, allow you to interpolate between keyframe sequences, and more.
	- Asset Pool - This view shows the existing assets in the Project, and allows you to add, change, or remove assets.
	- Curve Editor - This view shows the raw curves of the Transit, and allows you to edit, change, or remove the handles of the splines dictating the motion and appearance of the UI over time.
	- Script Editor - This view shows a script editor for running macros, shortcuts, and scripts on the current Hera project file.
5. Run - This tab allows you to configure and execute things for the project to run, and about its runtime behavior.
6. Editor - This view shows properties and settings for the plugin itself.

In addition to the tabs, there is a footer window that usually displays the following:
1. The Timeline - This UI object displays the current time and the time range of the current Project.
2. The Playback Controller - This UI object displays a play button, a pause button, a restart button, and also a button to toggle the current Keying mode.
3. The File Information Panel - This panel displays information about the current project, like its name.

## Project Format and Scripting Projects
Projects in the HTD Plugin are stored as `.hera` objects in Roblox Studio.