% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compare_metadata.R
\name{compare_files_content}
\alias{compare_files_content}
\title{Compare content of a specific file between two folders}
\usage{
compare_files_content(filename, dir1, dir2)
}
\arguments{
\item{filename}{A character string specifying the name of the file to compare.}

\item{dir1}{A character string specifying the path to the first folder.}

\item{dir2}{A character string specifying the path to the second folder.}
}
\value{
A list containing information about differences in the content of the specified file.
}
\description{
\code{compare_files_content()} reads the content of a specified file from two folders
and compares the content using the \code{waldo::compare} function. It identifies any
differences in the content and returns the comparison results.
}
\details{
\code{compare_files_content()} reads the content of the specified file from both folders using
\code{readLines()} and compares the content using the \code{waldo::compare()} function.
}
