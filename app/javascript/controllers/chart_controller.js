import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"]
  static values = { 
    chartData: Array,
    chartLabels: Array 
  }

  connect() {
    console.log("Chart controller connected!")
    this.createChart()
  }

  createChart() {
    const ctx = this.canvasTarget.getContext('2d')
    
    // 既存のチャートがあれば破棄
    if (this.chart) {
      this.chart.destroy()
    }

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.chartLabelsValue,
        datasets: [{
          label: '正答率 (%)',
          data: this.chartDataValue,
          borderColor: 'rgb(59, 130, 246)', // blue-500
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          borderWidth: 3,
          fill: true,
          tension: 0.4,
          pointBackgroundColor: 'rgb(59, 130, 246)',
          pointBorderColor: '#ffffff',
          pointBorderWidth: 2,
          pointRadius: 6,
          pointHoverRadius: 8
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          },
          title: {
            display: true,
            text: '過去10日間の正答率',
            font: {
              size: 16,
              weight: 'bold'
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            max: 100,
            ticks: {
              callback: function(value) {
                return value + '%'
              }
            }
          },
          x: {
            grid: {
              display: false
            }
          }
        },
        elements: {
          point: {
            hoverBorderWidth: 3
          }
        }
      }
    })
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
    }
  }
}